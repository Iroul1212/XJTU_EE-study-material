// Vercel Serverless Function — 发起 GitHub OAuth 授权
export default function handler(req, res) {
  const clientId = process.env.OAUTH_CLIENT_ID || 'Ov23liuxjOohNqFnQwJg';
  const redirectUri = process.env.OAUTH_REDIRECT_URI || 'https://xjtu-nyxf-study-material.vercel.app/api/callback';
  const scope = 'repo,user';
  const authUrl = `https://github.com/login/oauth/authorize?client_id=${clientId}&redirect_uri=${encodeURIComponent(redirectUri)}&scope=${scope}`;
  res.writeHead(302, { Location: authUrl });
  res.end();
}
