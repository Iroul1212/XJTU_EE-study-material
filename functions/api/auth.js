// Cloudflare Pages Function — 发起 GitHub OAuth 授权
export async function onRequest(context) {
  const { env } = context;
  const clientId = env.OAUTH_CLIENT_ID || 'Ov23liuxjOohNqFnQwJg';
  const redirectUri = env.OAUTH_REDIRECT_URI || 'https://xjtu-nyxf-study-material.pages.dev/api/callback';
  const scope = 'repo,user';
  const authUrl = `https://github.com/login/oauth/authorize?client_id=${clientId}&redirect_uri=${encodeURIComponent(redirectUri)}&scope=${scope}`;

  const html = `<!DOCTYPE html>
<html><head><script>
  if (window.opener) {
    window.opener.postMessage('authorizing:github', '*');
  }
  setTimeout(function() {
    window.location.href = '${authUrl}';
  }, 500);
</script></head><body><p>正在跳转到 GitHub 授权...</p></body></html>`;

  return new Response(html, {
    headers: { 'Content-Type': 'text/html; charset=utf-8' },
  });
}
