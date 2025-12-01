# Odin Documentation

This directory contains the Astro-based documentation site for Ascend Platform.

## 🚀 Quick Start

### Development

```bash
npm install
npm run dev
```

The site will be available at `http://localhost:4321/ascend/`

### Build

```bash
npm run build
```

The built site will be in the `dist/` directory.

### Preview Build

```bash
npm run preview
```

## 📝 Documentation Structure

### GitHub Pages Setup
- **Site URL**: `https://dream11.github.io/ascend/`
- **Base Path**: `/ascend/`
- **Repository**: `https://dream11.github.io/ascend`

### Documentation Sections

The documentation includes:

1. **Introduction**
   - Overview: What is Ascend and key features
   - Getting Started: Installation and create your first experiment

2. **Key Concepts**
   - Overview: Introduction to core concepts
   - Environment: Isolated namespaces for deployments
   - Service: Deployable application units
   - Component: Building blocks of services
   - Provisioning: How and where to deploy
   - Versioning: SNAPSHOT vs CONCRETE versions
   - Service Sets: Managing multiple services
   - Labels: Organization and filtering

3. **CLI Reference**
   - Complete command reference with examples
   - All flags and options documented
   - Output formats and configuration

4. **How-To Guides**
   - Deploy Your First Service
   - Dev to QA Iteration
   - Additional guides for common tasks

## 🎨 Customization

### Logo
The site uses Odin logo from `src/assets/odin-logo.png`

### Theme
Custom styles can be modified in `src/styles/custom.css`

## 📦 Dependencies

The site uses:
- Astro with Starlight theme
- Node.js and npm
- TypeScript

## 🚀 Deployment

This site is configured for GitHub Pages deployment:
1. GitHub Pages enabled in repository settings
2. Build workflow deploys to the `gh-pages` branch
3. Site published from the `gh-pages` branch

The site will be accessible at: `https://dream11.github.io/ascend/`

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

## 📚 Additional Resources

- [Astro Documentation](https://astro.build/)
- [Starlight Documentation](https://starlight.astro.build/)
- [Odin CLI Repository](../odin-cli/)
- [Odin Deployer Repository](../odin-deployer/)
