import json
import os
import smtplib
import subprocess
from email.message import EmailMessage

config_dir = "config"
config_file = os.path.join(config_dir, "crisis_config.json")
template_file = os.path.join(config_dir, "template_mail.html")
data_file = "exportfile.json"

config_defaut = {
    "cpu_threshold": 80.0,
    "ram_threshold": 85.0,
    "disk_threshold": 90.0,
    "admin_email": "matteo.jaubert@alumni.univ-avignon.fr",
    "smtp_server": "partage.univ-avignon.fr",
    "smtp_port": 465,
    "smtp_user": "matteo.jaubert@alumni.univ-avignon.fr",
    "smtp_pass": "mdp"
}

template_defaut = """
<html>
<body style="font-family: Arial, sans-serif;">
    <h2 style="color: red;">SITUATION DE CRISE ATTEINTE: </h2>
    <p>Le module de crise a détecté un dépassement :</p>
    <ul>
        <li><strong>CPU :</strong> {cpu}%</li>
        <li><strong>RAM :</strong> {ram}%</li>
        <li><strong>Disque :</strong> {disk}%</li>
        <li><strong>ORIGINE :</strong> {origine}%</li>
    </ul>
    <h3>Graphique :</h3>
    <img src="cid:graph">
</body>
</html>
"""

def init_files():
    if not os.path.exists(config_dir):
        os.makedirs(config_dir)
    if not os.path.exists(config_file):
        with open(config_file, 'w', encoding='utf-8') as f:
            json.dump(config_defaut, f, indent=4)
    if not os.path.exists(template_file):
        with open(template_file, 'w', encoding='utf-8') as f:
            f.write(template_defaut)

def get_data_from_json():
    if not os.path.exists(data_file):
        return None
    with open(data_file, 'r') as f:
        data = json.load(f)
    
    row_data = data['data']
    last_entry = row_data[-2]

    if last_entry[0] is not None:
        return {
            "cpu": round(last_entry[0], 2),
            "ram": round(last_entry[1], 2),
            "disk": round(last_entry[2], 2),
            "origine" : round(last_entry[3], 3),
        }
    return None

def generate_graph():
    graph_path = "graph.png"
    rrd_path = "/home/matteojaubert/ProjetFinalSysteme/system.rrd"

    cmd = [
        "rrdtool", "graph", graph_path,
        "--start", "-1h",
        "--title", "Utilisation des ressources (1h)",
        "--vertical-label", "%",
        f"DEF:cpu={rrd_path}:cpu:AVERAGE",
        f"DEF:ram={rrd_path}:ram:AVERAGE",
        f"DEF:disk={rrd_path}:memory:AVERAGE",
        f"DEF:origine={rrd_path}:origine:AVERAGE",
        "LINE1:cpu#FF0000:CPU",
        "LINE1:ram#00FF00:RAM",
        "LINE1:disk#0000FF:DISK",
        "LINE1:origine#FFFF00:ORIGINE"
    ]
    subprocess.run(cmd, check=True)
    return graph_path

def send_mail(stats):
    with open(config_file, 'r') as f:
        config = json.load(f)
    with open(template_file, 'r') as f:
        content = f.read().format(**stats)

    msg = EmailMessage()
    msg.set_content(content, subtype='html')
    msg['Subject'] = "[AUTOMATIQUE] Crise : Alerte Ressources Serveur"
    msg['From'] = config["smtp_user"]
    msg['To'] = config["admin_email"]

    graph_path = generate_graph()
    with open(graph_path, 'rb') as img:
        msg.add_attachment(img.read(),
                           maintype='image',
                           subtype='png',
                           filename="graph.png")

    try:
        # Pour le port 465, on utilise SMTP_SSL directement
        with smtplib.SMTP_SSL(config["smtp_server"], config["smtp_port"]) as server:
            server.login(config["smtp_user"], config["smtp_pass"])
            server.send_message(msg)
        print("Mail envoyé avec succès via le serveur de l'université.")
    except Exception as e:
        print(f"Erreur d'envoi SMTP : {e}")

init_files()
stats = get_data_from_json()

if stats:
    with open(config_file, 'r') as f:
        config = json.load(f)

    is_crisis = (stats["cpu"] >= config["cpu_threshold"] or 
                 stats["ram"] >= config["ram_threshold"] or 
                 stats["disk"] >= config["disk_threshold"])

    if is_crisis:
        print(f"ALERTE CRISE ! CPU:{stats['cpu']} RAM:{stats['ram']} DISK:{stats['disk']}")
        send_mail(stats)
    else:
        print(f"OK. CPU:{stats['cpu']} RAM:{stats['ram']} DISK:{stats['disk']}")
else:
    print("Erreur : Impossible de lire les données JSON.")
