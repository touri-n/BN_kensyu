import http.server
import cgi

class SimpleHTTPRequestHandler(http.server.BaseHTTPRequestHandler):
    def do_POST(self):
        # multipart/form-data の解析
        form = cgi.FieldStorage(
            fp=self.rfile,
            headers=self.headers,
            environ={
                'REQUEST_METHOD': 'POST',
                'CONTENT_TYPE': self.headers['Content-Type'],
            }
        )
        # "file"というフィールドからファイルを取り出す
        fileitem = form['file']
        if fileitem.filename:
            # ファイルを保存
            filename = fileitem.filename
            with open(filename, 'wb') as f:
                f.write(fileitem.file.read())
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b'File uploaded successfully!\n')
        else:
            self.send_response(400)
            self.end_headers()
            self.wfile.write(b'No file uploaded\n')

if __name__ == '__main__':
    server_address = ('', 8000)
    httpd = http.server.HTTPServer(server_address, SimpleHTTPRequestHandler)
    print("Serving at port 8000")
    httpd.serve_forever()
                             
