# Ascend Documentation

This directory contains the Astro-based documentation site for Ascend Platform.

---

## 🚀 Quick Start

### Development

```bash
npm install
npm run dev
```

The site will be available at `http://localhost:4321/`

### Build

```bash
npm run build
```

The built site will be in the `dist/` directory.

---

### Preview Build

```bash
npm run preview
```

---

## 📝 Documentation Structure

### GitHub Pages Setup
- **Site URL**: `https://ascend.dreamhorizon.org/`
- **Base Path**: `/`
- **Repository**: `https://dream-horizon-org.github.io/ascend`

### Documentation Sections

The documentation includes:

1. **Introduction**
   - Overview: What is Ascend and key features
   - Getting Started: Installation and create your first experiment

2. **Key Concepts**
   - Overview: Introduction to core concepts
   - Assignment Strategies
   - Experiment Lifecycle
   - Architecture Overview
   - Use cases

3. **How-To Guides**
   - Deploy Your First Service
   - Dev to QA Iteration
   - Additional guides for common tasks

---

## 🎨 Customization

### Logo
The site uses Ascend logo from `src/assets/ascend-logo.png`

### Theme
Custom styles can be modified in `src/styles/custom.css`

---

## 📦 Dependencies

The site uses:
- Astro with Starlight theme
- Node.js and npm
- TypeScript

---

## 🚀 Deployment

This site is configured for GitHub Pages deployment:
1. GitHub Pages enabled in repository settings
2. Build workflow deploys to the `gh-pages` branch
3. Site published from the `gh-pages` branch

The site will be accessible at: `https://ascend.dreamhorizon.org/`

---

## 📚 Content Guidelines

When adding new documentation:

1. **Use MDX format** for all content files
2. **Include frontmatter** with title and description
3. **Add to sidebar** in `astro.config.mjs`
4. **Use code examples** liberally
5. **Link between pages** using relative paths
6. **Follow the existing structure**:
   - Concepts: Explain what something is
   - How-To: Step-by-step instructions
   - Reference: Complete technical details

---

## 📚 Additional Resources

- [Astro Documentation](https://astro.build/)
- [Starlight Documentation](https://starlight.astro.build/)
- [Testlab Experiment Backend]()
- [Flockr Audience Backend]()
- [Licence] MIT License

