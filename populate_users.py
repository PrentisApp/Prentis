import firebase_admin
from firebase_admin import credentials
from google.cloud import firestore

cred = credentials.Certificate("prentisapp-50e4e-firebase-adminsdk-vvo4f-67dfbe422e.json")
firebase_admin.initialize_app(cred)
db = firestore.Client()

doc_ref = db.collection('User').document('Shakeeb')
doc_ref.set({
    "first": "Shakeeb",
    "last": "Majid",
    "birfday": "05/09/1999996"
})

users_ref = db.collection("User")

docs = users_ref.get()
for doc in docs:
    print(doc.id, doc.to_dict())
    

