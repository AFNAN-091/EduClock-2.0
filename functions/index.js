const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotificationToAllUsers = functions.database
    .ref('departments/{department}/{semester}/{session}/{eventType}/{eventId}')
    .onCreate(async (snapshot, context) => {
        const department = context.params.department;
        const semester = context.params.semester;
        const eventType = context.params.eventType;
        const session = context.params.session;

        const data = snapshot.val();
        const courseName = (data.courseName || 'Unknown Course').replace(/(^"|"$)/g, '');
        const dateTime = (data.date || 'Date not provided').replace(/(^"|"$)/g, '');
        const startTime = (data.startTime || 'Time not provided').replace(/(^"|"$)/g, '');
        const noticeTitle = (data.title || 'Title not provided').replace(/(^"|"$)/g, '');
        const examType = (data.examType || 'Exam Type not provided').replace(/(^"|"$)/g, '');


        console.log('Data:', data); // Check the full data
        console.log('courseName:', data.courseName); // Check courseName field
        console.log('date:', data.date); // Check date field
        console.log('startTime:', data.startTime); // Check startTime field


        let title = '';
        let body = '';

        switch (eventType) {
            case 'tasks':
                title = `${courseName} Has Been Scheduled`;
                body = `On:${dateTime}, ${startTime}\nDept: ${department}, Sem: ${semester}/${session}`;
                break;
            case 'notices':
                title = 'Notice';
                body = `${noticeTitle}\nDept: ${department}, Sem: ${semester}/${session}`;
                break;
            case 'exams':
                title = `${courseName} Exam Slot Confirmed`;
                body = `${examType} exam\nScheduled on: ${dateTime}, ${startTime}\nDept: ${department}, Sem: ${semester}/${session}`;
                break;
            default:
                title = 'New Event';
                body = `A new event has been added in the ${department} department, semester ${eventType}.`;
                break;
        }

        // Define a condition to send notifications to devices subscribed to both topics
        // const condition = department;

        const message = {
            notification: {
                title: title,
                body: body,
            },
            data: {
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
                department: department,
                eventType: eventType,
                // semester: semester,
                // eventId: context.params.eventId,
            },
            topic: department,
        };

        try {
            const response = await admin.messaging().send(message);
            console.log('Successfully sent message:', response);
        } catch (error) {
            console.error('Error sending message:', error);
        }

        return null;
    });
