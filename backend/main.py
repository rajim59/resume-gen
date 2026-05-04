import os
import json
import pdfplumber
from google.cloud import firestore
from flask import Request, jsonify

def get_firestore_client():
    """Firestore ক্লায়েন্ট তৈরি - লোকাল ইমুলেটর স্বয়ংক্রিয়ভাবে ডিটেক্ট করবে"""
    return firestore.Client(project=os.getenv("GOOGLE_CLOUD_PROJECT", "local-test"))

def handle_parse_pdf(request: Request):
    """পিডিএফ পার্স করে JSON ডাটা রিটার্ন করবে"""
    sample_data = {
        "name": "Test User",
        "email": "test@example.com",
        "skills": ["Python", "Docker", "GCP"],
        "experience": [
            {"company": "Test Corp", "role": "Developer", "duration": "2023-Present"}
        ]
    }
    return jsonify(sample_data)

def handle_build_resume(request: Request):
    """Firestore থেকে ডাটা নিয়ে HTML তৈরি করবে"""
    db = get_firestore_client()
    doc_ref = db.collection("resumes").document("sample")
    
    doc = doc_ref.get()
    if not doc.exists:
        doc_ref.set({
            "name": "John Doe",
            "email": "john@example.com", 
            "skills": ["Python", "GCP", "Docker"]
        })
        doc = doc_ref.get()
    
    return jsonify(doc.to_dict())

def main_entry(request: Request):
    """
    Master Router: লোকাল ইমুলেটরে একাধিক ফাংশন টেস্ট করার জন্য 
    এটি ট্রাফিক রাউট করবে।
    """
    path = request.path
    
    if path == "/build":
        return handle_build_resume(request)
    else:
        # ডিফল্ট রাউট (/) parse_pdf কে হিট করবে
        return handle_parse_pdf(request)