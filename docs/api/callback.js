// Vercel Serverless Function — 处理 GitHub OAuth 回调，返回 token 给 CMS
export default async function handler(req, res) {
  const { code } = req.query;
  if (!code) {
    res.statusCode = 400;
    res.end('Missing code parameter');
    return;
  }

  const clientId = process.env.OAUTH_CLIENT_ID || 'Ov23liuxjOohNqFnQwJg';
  const clientSecret = process.env.OAUTH_CLIENT_SECRET || '0f9dc3d30212f65edcf1e1b447e9cab683c04cf5';

  const tokenRes = await fetch('https://github.com/login/oauth/access_token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
    body: JSON.stringify({ client_id: clientId, client_secret: clientSecret, code }),
  });

  const data = await tokenRes.json();
  if (data.error) {
    res.statusCode = 400;
    res.end(`OAuth Error: ${data.error_description || data.error}`);
    return;
  }

  // Decap CMS 通过 postMessage 接收 token（必须是字符串格式）
  res.setHeader('Content-Type', 'text/html; charset=utf-8');
  res.end(`<!DOCTYPE html>
<html><head><script>
  var token = '${data.access_token}';
  var payload = JSON.stringify({ token: token, provider: 'github' });
  var msg = 'authorization:github:success:' + payload;
  window.opener.postMessage(msg, '*');
</script></head><body><p>授权成功，窗口即将关闭...</p></body></html>`);
}
