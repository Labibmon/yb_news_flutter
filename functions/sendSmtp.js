const fetch = require('node-fetch');

exports.handler = async function(event, context) {
  try {
    const { toEmail, subject, text } = JSON.parse(event.body);

    const apiUrl = 'https://send.api.mailtrap.io/api/send';
    const apiToken = '75eb28801763edb1dcf2e1cc67d30108';
    const senderEmail = 'hello@demomailtrap.co';
    const senderName = 'OTP Service';

    const body = {
      from: {
        email: senderEmail,
        name: senderName
      },
      to: [
        { email: toEmail }
      ],
      subject: subject,
      text: text
    };

    const response = await fetch(apiUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Api-Token': apiToken
      },
      body: JSON.stringify(body)
    });

    const data = await response.json();

    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'Email sent successfully', data })
    };

  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Failed to send email', error: error.message })
    };
  }
};
