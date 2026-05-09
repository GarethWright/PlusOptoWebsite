// Plus Opto — Contact Form Proxy Worker
// Deploy this to Cloudflare Workers.
export default {
  async fetch(request, env) {

    // CORS preflight
    if (request.method === 'OPTIONS') {
      return new Response(null, {
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'POST, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type'
        }
      });
    }

    if (request.method !== 'POST') {
      return json({ error: 'Method not allowed' }, 405);
    }

    let data;
    try {
      data = await request.json();
    } catch {
      return json({ error: 'Invalid JSON' }, 400);
    }

    const { name, company, email, phone, message } = data;

    if (!name || !email || !message) {
      return json({ error: 'Missing required fields' }, 400);
    }

    let body = `Name: ${name}\n`;
    if (company) body += `Company: ${company}\n`;
    body += `Email: ${email}\n`;
    if (phone)   body += `Phone: ${phone}\n`;
    body += `\nMessage:\n${message}`;

    const resendRes = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${env.RESEND_API_KEY}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        from:     'contact@plusopto.com',
        to:       ['sales@plusopto.co.uk'],
        subject:  `Website enquiry from ${name}`,
        text:     body,
        reply_to: email
      })
    });

    const result = await resendRes.json();

    if (resendRes.ok) {
      return json({ id: result.id });
    } else {
      return json({ error: result }, 500);
    }
  }
};

function json(data, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*'
    }
  });
}
