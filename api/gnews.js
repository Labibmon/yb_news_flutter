export default async function handler(req, res) {
  const {
    category = 'general',
    q = '',
    max = 10,
    lang = 'en',
    country = 'us',
  } = req.query;

  const url =
    `https://gnews.io/api/v4/top-headlines` +
    `?category=${category}` +
    `&q=${encodeURIComponent(q)}` +
    `&max=${max}` +
    `&lang=${lang}` +
    `&country=${country}` +
    `&token=8bb34f7f254c711d9adaeca109f34109`;

  try {
    const response = await fetch(url);
    const data = await response.json();

    res.setHeader('Access-Control-Allow-Origin', '*');
    res.status(200).json(data);
  } catch (error) {
    res.status(500).json({
      error: 'Failed to fetch GNews',
      details: error.message,
    });
  }
}
