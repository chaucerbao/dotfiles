return {
  s('//i', t('// Imports')),
  s('//t', t('// Type Definitions')),
  s('//c', t('// Constants')),
  s('//h', t('// Helpers')),
  s('//e', t('// Exports')),

  s('log', { t('console.log('), i(1, ''), t(')'), i(0) }),
  s('jst', { t('JSON.stringify('), i(1, ''), t(', null, 2)'), i(0) }),

  s('wc', {
    t('class '),
    i(1, 'CustomElement'),
    t({
      ' extends HTMLElement {',
      '\tstatic observedAttributes = []',
      '',
      '\tconstructor() {',
      '\t\tsuper()',
      '\t\t',
    }),
    i(0),
    t({
      '',
      '\t}',
      '',
      '\tconnectedCallback() {}',
      '\tdisconnectedCallback() {}',
      '\tadoptedCallback() {}',
      '\tattributeChangedCallback() {}',
      '}',
      '',
      "window.customElements.define('",
    }),
    f(function(args)
      return args[1][1]
        :gsub('%u', function(c)
          return '-' .. c:lower()
        end)
        :gsub('^-', '')
    end, { 1 }),
    t("', "),
    rep(1),
    t(')'),
  }),
}
