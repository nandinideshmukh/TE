import datetime
from nltk.chat.util import Chat, reflections

def confirm_booking(symptom, slot):
    """Calculates the date and returns a confirmation message."""
    today = datetime.date.today().strftime("%d %B, %Y")
    return (f"\n Appointment confirmed!\n"
            f"Symptom: {symptom}\n"
            f"Time: {slot}\n"
            f"Date: {today}\n"
            f"Please arrive 10 minutes early. Get well soon!")

symptoms_data = {
    'mild fever': ['9:00 AM', '1:30 PM', '5:00 PM', '8:00 PM'],
    'slight cough': ['10:00 AM', '2:30 PM', '6:30 PM'],
    'minor headache': ['8:30 AM', '12:30 PM', '4:00 PM'],
    'fatigue': ['11:00 AM', '3:00 PM']
}

patterns = [
    (r'.*hi.*|.*hello.*|.*hey.*', 
     ['Hello! I can help book appointments for mild symptoms.', 
      'Hi there! Which symptom are you feeling today?']),
    
    (r'how are you', 
     ['I am a helpful assistant, ready to book your appointment!', 
      'Doing great, thanks for asking!']),
    
    (r'.*symptom.*|.*help.*|.*available.*', 
     ['I can help with: ' + ', '.join(symptoms_data.keys()) + '. Which one do you have?']),
    
    (r'.*mild fever.*', 
     ['You mentioned mild fever. Available slots: ' + ', '.join(symptoms_data['mild fever'])]),
    
    (r'.*slight cough.*', 
     ['You mentioned slight cough. Available slots: ' + ', '.join(symptoms_data['slight cough'])]),
    
    (r'.*minor headache.*', 
     ['You mentioned minor headache. Available slots: ' + ', '.join(symptoms_data['minor headache'])]),
    
    (r'.*fatigue.*', 
     ['You mentioned fatigue. Available slots: ' + ', '.join(symptoms_data['fatigue'])]),
    
    (r'.*book.*9:00 AM.*', [confirm_booking('mild fever', '9:00 AM')]),
    (r'.*book.*1:30 PM.*', [confirm_booking('mild fever', '1:30 PM')]),
    (r'.*book.*5:00 PM.*', [confirm_booking('mild fever', '5:00 PM')]),
    (r'.*book.*8:00 PM.*', [confirm_booking('mild fever', '8:00 PM')]),
    
    (r'.*book.*10:00 AM.*', [confirm_booking('slight cough', '10:00 AM')]),
    (r'.*book.*2:30 PM.*', [confirm_booking('slight cough', '2:30 PM')]),
    (r'.*book.*6:30 PM.*', [confirm_booking('slight cough', '6:30 PM')]),
    
    (r'.*book.*8:30 AM.*', [confirm_booking('minor headache', '8:30 AM')]),
    (r'.*book.*12:30 PM.*', [confirm_booking('minor headache', '12:30 PM')]),
    (r'.*book.*4:00 PM.*', [confirm_booking('minor headache', '4:00 PM')]),
    
    (r'.*book.*11:00 AM.*', [confirm_booking('fatigue', '11:00 AM')]),
    (r'.*book.*3:00 PM.*', [confirm_booking('fatigue', '3:00 PM')]),
    
    (r'.*bye.*|.*quit.*|.*exit.*', 
     ['Goodbye! Take care and stay healthy.', 
      'Bye! Hope you feel better soon.']),
    
    (r'(.*)', 
     ['I am not sure I understand. Tell me your symptoms. To see available symptoms type "symptom".'])
]

med_bot = Chat(patterns, reflections)

def main():
    print("--- Welcome to the Health Booking Bot ---")
    print("(Type 'bye' to exit or 'symptom' to start)")

    while True:
        try:
            user_input = input("You: ").lower().strip()
            
            response = med_bot.respond(user_input)
            print("ChatBot:", response)
            
            if any(word in user_input for word in ['bye', 'goodbye', 'quit', 'exit']):
                break
        
        except KeyboardInterrupt:
            print("\nChatBot: Goodbye!")
            break

if __name__ == "__main__":
    main()