const fs = require('fs');
const path = require('path');

const COURSES_DIR = path.join(__dirname, '..', 'courses');

if (!fs.existsSync(COURSES_DIR)) {
  console.log('docs/courses/ 目录不存在');
  process.exit(0);
}

const files = fs.readdirSync(COURSES_DIR).filter(f => f.endsWith('.md'));

let count = 0;
for (const file of files) {
  const content = fs.readFileSync(path.join(COURSES_DIR, file), 'utf-8');
  const match = content.match(/^---\r?\n([\s\S]*?)\r?\n---/);
  if (!match) continue;

  const fm = {};
  for (const line of match[1].split('\n')) {
    const idx = line.indexOf(':');
    if (idx > 0) fm[line.slice(0, idx).trim()] = line.slice(idx + 1).trim();
  }

  if (!fm.title) continue;

  // 课程根文件夹路径（仓库根目录 = ../../ 从 scripts/ 算, ../ 从 docs/ 算）
  // 脚本在 docs/scripts/，仓库根在 ../../
  const repoRoot = path.join(__dirname, '..', '..');
  const courseFolder = path.join(repoRoot, fm.title);

  if (!fs.existsSync(courseFolder)) {
    fs.mkdirSync(courseFolder, { recursive: true });
  }

  const readmePath = path.join(courseFolder, 'README.md');
  // 只在不存在时创建，不覆盖已有内容
  if (!fs.existsSync(readmePath)) {
    const readme = `# ${fm.icon || '📖'} ${fm.title}

> ${fm.category || ''}${fm.subcategory ? ' / ' + fm.subcategory : ''}

欢迎贡献本课程的学习资料！
`;
    fs.writeFileSync(readmePath, readme, 'utf-8');
    console.log(`✅ 创建: ${fm.title}/README.md`);
    count++;
  } else {
    console.log(`⏭️  已存在: ${fm.title}/README.md`);
  }
}

console.log(`\n共创建 ${count} 个 README.md`);
