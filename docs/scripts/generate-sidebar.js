/**
 * 自动生成 _sidebar.md
 * 扫描 docs/courses/*.md 的 frontmatter（category、subcategory、icon、title）
 * 按分类/子分类组织，输出到 docs/_sidebar.md
 */

const fs = require('fs');
const path = require('path');

const COURSES_DIR = path.join(__dirname, '..', 'courses');
const SIDEBAR_PATH = path.join(__dirname, '..', '_sidebar.md');

// 分类结构定义（顺序即侧边栏顺序）
const STRUCTURE = {
  '公共课程': {
    icon: '📚',
    sub: ['思政类', '数学类', '物理与化学', '其他公共课']
  },
  '电气专业': {
    icon: '⚡',
    sub: ['专业核心课', '实验与实践']
  },
  '电子专业': {
    icon: '📡',
    sub: ['专业核心课', '实验与实践']
  },
  '微电子专业': {
    icon: '💻',
    sub: ['专业核心课', '实验与实践']
  }
};

function parseFrontmatter(filePath) {
  const content = fs.readFileSync(filePath, 'utf-8');
  const match = content.match(/^---\r?\n([\s\S]*?)\r?\n---/);
  if (!match) return null;
  const fm = {};
  for (const line of match[1].split('\n')) {
    const idx = line.indexOf(':');
    if (idx > 0) fm[line.slice(0, idx).trim()] = line.slice(idx + 1).trim();
  }
  return fm;
}

function encodePath(name) {
  return name.replace(/&/g, '%26');
}

function main() {
  const courses = [];

  if (fs.existsSync(COURSES_DIR)) {
    for (const file of fs.readdirSync(COURSES_DIR)) {
      if (!file.endsWith('.md')) continue;
      const fm = parseFrontmatter(path.join(COURSES_DIR, file));
      if (!fm || !fm.title) continue;
      courses.push({
        title: fm.title,
        category: fm.category || '公共课程',
        subcategory: fm.subcategory || '其他公共课',
        icon: fm.icon || '📖',
        folder: encodePath(fm.title)
      });
    }
  }

  const out = [];
  out.push('<!-- docs/_sidebar.md -->');
  out.push('');
  out.push('- [🏠 网站首页](/)');
  out.push('');

  // 贡献资料（固定）
  out.push('- **📤 贡献资料**');
  out.push('    - [🖥️ 网页上传（CMS后台）](admin/)');
  out.push('    - [📝 图文教程](贡献指南.md)');
  out.push('    - [🚀 GitHub直传](https://github.com/Iroul1212/XJTU_EE-study-material/upload/main)');
  out.push('    - [💬 提建议/传附件](https://github.com/Iroul1212/XJTU_EE-study-material/issues/new/choose)');
  out.push('');

  // 按分类/子分类输出课程
  for (const [category, cfg] of Object.entries(STRUCTURE)) {
    out.push(`- **${cfg.icon} ${category}**`);
    for (const subcat of cfg.sub) {
      const items = courses.filter(c => c.category === category && c.subcategory === subcat);
      out.push(`    - **${subcat}**`);
      if (items.length > 0) {
        for (const c of items) {
          out.push(`        - [${c.icon} ${c.title}](../${c.folder}/)`);
        }
      } else {
        out.push('        - *待补充...*');
      }
    }
    out.push('');
  }

  // 相关链接（固定）
  out.push('- **🔗 相关链接**');
  out.push('    - [GitHub 仓库](https://github.com/Iroul1212/XJTU_EE-study-material)');
  out.push('');

  fs.writeFileSync(SIDEBAR_PATH, out.join('\n'), 'utf-8');
  console.log(`✅ _sidebar.md 已自动生成，共 ${courses.length} 门课程`);
}

main();
