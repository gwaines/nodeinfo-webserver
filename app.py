from flask import Flask
import os
import socket
import platform
import multiprocessing

app = Flask(__name__)

def get_ip():
    return socket.gethostbyname(socket.gethostname())

def get_image_name():
    imageStr = "/static/NodeInfoOnTITANIUMCENTOS.png"
    platformStr = platform.platform()
    if platformStr.__contains__("yocto"):
        imageStr = "/static/NodeInfoOnWRLINUX.png"
    return imageStr


@app.route("/")
def hello():
    html = "<CENTER><h2>Node Info {name} ({buildVersion})</h2></CENTER>" \
           "<CENTER><h4>[ Build Date: {buildDate} ]</h4></CENTER>" \
           "<CENTER><IMG SRC=\"{imageName}\" ALIGN=\"TOP\"></CENTER>" \
	   "<HR>" \
	   "<b>Container:</b><br/>" \
	   "<b>&nbsp&nbsp&nbsp&nbsp IP Address:</b> {ipaddr}<br/>" \
	   "<b>&nbsp&nbsp&nbsp&nbsp Container :</b> {container}<br/>" \
	   "<br/>" \
	   "<b>Host      :</b><br/>" \
	   "<b>&nbsp&nbsp&nbsp&nbsp Platform  :</b> {plat}<br/>" \
	   "<b>&nbsp&nbsp&nbsp&nbsp Machine   :</b> {mach}<br/>" \
	   "<b>&nbsp&nbsp&nbsp&nbsp Node      :</b> {node}<br/>" \
	   "<b>&nbsp&nbsp&nbsp&nbsp System    :</b> {sys}<br/>" \
	   "<b>&nbsp&nbsp&nbsp&nbsp Release   :</b> {rel}<br/>" \
	   "<b>&nbsp&nbsp&nbsp&nbsp Version   :</b> {version}<br/>" \
	   "<b>&nbsp&nbsp&nbsp&nbsp Uname     :</b> {uname}<br/>" \
	   "<br/>" \
	   "<b>Resources :</b><br/>" \
	   "<b>&nbsp&nbsp&nbsp&nbsp CPUs      :</b> {cpus}<br/>" \
	   "<b>&nbsp&nbsp&nbsp&nbsp Memory(GB):</b> {memory}<br/>" \
	   "<HR>"
    return html.format(name=os.getenv("NAME", "Web Server"), 
                       buildVersion=os.getenv("VERSIONID", "Unknown Version"), 
                       buildDate=os.getenv("BUILDDATE", "Unknown Build Date"), 
                       imageName=get_image_name(), 
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

