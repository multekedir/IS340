from flask import Flask, flash, request, redirect, url_for
import os
#from werkzeug.utils import secure_filename
import subprocess

UPLOAD_FOLDER = './uploads'
ALLOWED_EXTENSIONS = set(['xml', 'xsl'])

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

app = Flask(__name__)

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

# subprocess.getoutput("sudo xsltproc --stringparam schemaTypes ENTITY --stringparam dataTypes 'ID=CHAR(10);REF=CHAR(10);VARCHAR=VARCHAR(32);TIMESTAMP=TIMESTAMP;INT=INT;STR=TEXT;DATE=DATE;NAME=CHAR(20);PHONE=VARCHAR(12);BIT=BIT;' tableSchema_SQL.xsl Rideshare.xml")

@app.route('/',methods=['GET','POST'])
def home():
    if request.method = 'POST':
        if 'file' not in request.files:
            flash('No file part')
            return redirect(request.url)
        file = request.files['file']
        if file.filename == '':
            flash('No selected file')
            return redirect(request.url)
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            return redirect(url_for('uploaded_file', filename=filename))

     return '''
    <!doctype html>
    <title>Upload new File</title>
    <h1>Upload new File</h1>
    <form method=post enctype=multipart/form-data>
      <input type=file name=file>
      <input type=submit value=Upload>
    </form>
    '''


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=80)
