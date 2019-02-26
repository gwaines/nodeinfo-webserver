from flask import Flask
import os
import socket
import platform
import multiprocessing

app = Flask(__name__)

def get_ip():
    return socket.gethostbyname(socket.gethostname())


@app.route("/")
def hello():
    html = "<CENTER><h2>Node Info {name}</h2></CENTER>" \
           "<CENTER><IMG SRC=\"/static/smallNodeinfo.png\" ALIGN=\"TOP\"></CENTER>" \
	   "<HR>" \
	   "<b>Container:</b><br/>" \
	   "<b>&nbsp&nbsp&nbsp&nbsp IP Address:</b> {ipaddr}<br/>" \
	   "<b>&nbsp&nbsp&nbsp&nbsp Container :</b> {container}<br/>" \
	   "<br/>" \
	   "<b>Platform  :</b> {plat}<br/>" \
	   "<b>Machine   :</b> {mach}<br/>" \
	   "<b>Node      :</b> {node}<br/>" \
	   "<b>System    :</b> {sys}<br/>" \
	   "<b>Release   :</b> {rel}<br/>" \
	   "<b>Version   :</b> {version}<br/>" \
	   "<b>Uname     :</b> {uname}<br/>" \
	   "<b>CPUs      :</b> {cpus}<br/>" \
	   "<b>MEMORY    :</b> {memory}<br/>" \
	   "<HR>"
    return html.format(name=os.getenv("NAME", "Web Server"), 
                       ipaddr=get_ip(), 
		       container=socket.gethostname(), 
		       plat=platform.platform(),
		       mach=platform.machine(),
		       node=platform.node(),
		       sys=platform.system(),
		       rel=platform.release(),
		       version=platform.version(),
		       uname=platform.uname(),
		       cpus=multiprocessing.cpu_count(),
		       memory=((os.sysconf('SC_PAGE_SIZE') * os.sysconf('SC_PHYS_PAGES'))/(1024.**3)))

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)

