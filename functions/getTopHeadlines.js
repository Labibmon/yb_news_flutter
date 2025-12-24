const fetch = require('node-fetch');

exports.handler = async function(event, context) {
  const category = event.queryStringParameters?.category || 'general';
  const query = event.queryStringParameters?.query || '';
  const max = event.queryStringParameters?.max || '10';
  
  const apiKey = '8bb34f7f254c711d9adaeca109f34109'; // replace with your GNews API key

  const response = await fetch(
    `https://gnews.io/api/v4/top-headlines?country=us&lang=en&max=${max}&category=${category}&q=${query}&apikey=${apiKey}`
  );

  const data = await response.json();

  return {
    statusCode: 200,
    headers: {
      'Access-Control-Allow-Origin': '*', // allow all origins
    },
    body: JSON.stringify(data),
  };
}
