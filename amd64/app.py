from flask import Flask
import os
import socket
import platform

app = Flask(__name__)

def get_ip():
    return socket.gethostbyname(socket.gethostname())


@app.route("/")
def hello():
    html = "<h3>Node Info {name}!</h3>" \
	   "<b>IP Address:</b> {ipaddr}<br/>" \
	   "<b>Container :</b> {container}<br/>" \
	   "<b>Platform  :</b> {plat}<br/>" \
	   "<HR>" \
	   "<CENTER><IMG SRC=\"/static/nodeinfo.png\" ALIGN=\"BOTTOM\"> </CENTER>" \
	   "<HR>"
    return html.format(name=os.getenv("NAME", "Web Server"), ipaddr=get_ip(), container=socket.gethostname(), plat=platform.platform())

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)

