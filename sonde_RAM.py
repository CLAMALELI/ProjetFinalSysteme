import psutil

psutil.virtual_memory().available * 100 / psutil.virtual_memory().total
