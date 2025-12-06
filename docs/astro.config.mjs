import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
  site: 'https://dream11.github.io/ascend/',
  base: '/ascend/',
  integrations: [
    starlight({
      title: 'Ascend',
      description: 'Ascend - Product Growth Experimentation & Targeting Platform',
      favicon: '/ascend-logo.png',
      logo: {
        src: './src/assets/ascend-logo.png',
      },
      social: [
        {
          icon: 'github',
          label: 'GitHub',
          href: 'https://dream11.github.io/ascend/',
        },
      ],
      sidebar: [
        {
          label: 'Introduction',
          items: [
            'introduction/overview',
            'introduction/getting-started',
             'introduction/why-use-ascend',
          ],
        },
        {
          label: 'Key Concepts',
          items: [
            'concepts/overview'
          ],
        },
         {
          label: 'SDKs',
          items: [
          {
              label: 'Android',
                         items:[
                             'sdks/kotlin/installation',
                             'sdks/kotlin/quick-start',
                             'sdks/kotlin/api'


                              ],
              },
          {
                        label: 'iOS',
                                   items:[
                                       'sdks/ios/installation',
                                        'sdks/ios/quick-start',
                                       'sdks/ios/api'

                                        ],
                        },
                    {
                                  label: 'React Native',
                                             items:[
                                                 'sdks/react-native/installation',
                                                  'sdks/react-native/quick-start',
                                                 'sdks/react-native/api'

                                                  ],
                                  },

          ],
       },
        {
          label: 'How-To Guides',
          items: [
            'howto/how-to-contribute',
            'howto/create-first-experiment'
            ],
        },
      ],
      customCss: ['./src/styles/custom.css'],
      tableOfContents: {
        minHeadingLevel: 2,
        maxHeadingLevel: 4,
      },
      pagination: true,
    }),
  ],
  server: {
    port: 4321,
    host: true,
  },
});
