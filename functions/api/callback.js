// Cloudflare Pages Function — 处理 GitHub OAuth 回调，返回 token 给 CMS
export async function onRequest(context) {
  const { request, env } = context;
  const url = new URL(request.url);
  const code = url.searchParams.get('code');

  if (!code) {
    return new Response('Missing code parameter', { status: 400 });
  }

  const clientId = env.OAUTH_CLIENT_ID || 'Ov23liuxjOohNqFnQwJg';
  const clientSecret = env.OAUTH_CLIENT_SECRET || '0f9dc3d30212f65edcf1e1b447e9cab683c04cf5';

  const tokenRes = await fetch('https://github.com/login/oauth/access_token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
    body: JSON.stringify({ client_id: clientId, client_secret: clientSecret, code }),
  });

  const data = await tokenRes.json();
  if (data.error) {
    return new Response(`OAuth Error: ${data.error_description || data.error}`, { status: 400 });
  }

  const html = `<!DOCTYPE html>
<html><head><script>
  var token = '${data.access_token}';
  var payload = JSON.stringify({ token: token, provider: 'github' });
  var msg = 'authorization:github:success:' + payload;
  window.opener.postMessage(msg, '*');
</script></head><body><p>授权成功，窗口即将关闭...</p></body></html>`;

  return new Response(html, {
    headers: { 'Content-Type': 'text/html; charset=utf-8' },
  });
}
