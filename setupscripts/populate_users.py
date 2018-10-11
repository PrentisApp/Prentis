import firebase_admin
from firebase_admin import credentials
from firebase_admin import auth
from google.cloud import firestore
from users import users

cred = credentials.Certificate("prentisapp-50e4e-firebase-adminsdk-vvo4f-67dfbe422e.json")
firebase_admin.initialize_app(cred)
db = firestore.Client()

users_ref = db.collection("User")

docs = users_ref.get()
for doc in docs:
    doc_ref = db.collection('User').document(doc.id)
    doc_ref.delete()
for user in auth.list_users().iterate_all():
    print('User: ' + user.uid)
    auth.delete_user(user.uid)
for user in users:
    doc_ref = db.collection('User').document(user["uid"])
    doc_ref.create(user)
    auth.create_user(
    uid = user["uid"],
    email = user["email"],
    email_verified=False,
    password='password',
    display_name=user["username"],
    disabled=False)
