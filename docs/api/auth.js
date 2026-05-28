// Vercel Serverless Function — 发起 GitHub OAuth 授权
export default function handler(req, res) {
  const clientId = process.env.OAUTH_CLIENT_ID;
  const redirectUri = process.env.OAUTH_REDIRECT_URI;

  // 如果环境变量未配置，返回调试信息
  if (!clientId || !redirectUri) {
    res.status(200).json({
      error: '环境变量未配置',
      OAUTH_CLIENT_ID: clientId || '(空)',
      OAUTH_REDIRECT_URI: redirectUri || '(空)',
      envKeys: Object.keys(process.env).filter(k => k.startsWith('OAUTH') || k.startsWith('VERCEL')),
    });
    return;
  }

  const scope = 'repo,user';
  const authUrl = `https://github.com/login/oauth/authorize?client_id=${clientId}&redirect_uri=${encodeURIComponent(redirectUri)}&scope=${scope}`;
  res.writeHead(302, { Location: authUrl });
  res.end();
}
