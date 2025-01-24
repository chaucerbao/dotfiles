return {
  -- Comments
  { prefix = '//i', body = '// Imports' },
  { prefix = '//t', body = '// Type Definitions' },
  { prefix = '//c', body = '// Constants' },
  { prefix = '//s', body = '// Styles' },
  { prefix = '//h', body = '// Helpers' },
  { prefix = '//e', body = '// Exports' },

  { prefix = 'im', body = "import { $0 } from '$1'" },
  { prefix = 'log', body = 'console.log($0)' },
  { prefix = 'logj', body = 'console.log(JSON.stringify($0, null, 2))' },
  { prefix = 'iife', body = ';(() => {\n\t$0\n})()' },
  { prefix = 'aiife', body = ';(async () => {\n\t$0\n})()' },

  {
    prefix = 'fc',
    body = 'interface ${1:Component}Props {\n\t$2\n}\n\nconst $1: React.FunctionComponent<$1Props> = (props) => {\n\t$0\n}',
  },
}
