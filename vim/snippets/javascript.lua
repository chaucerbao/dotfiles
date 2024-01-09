return {
  s('//i', t('// Imports')),
  s('//t', t('// Type Definitions')),
  s('//c', t('// Constants')),
  s('//h', t('// Helpers')),
  s('//e', t('// Exports')),

  s('log', { t('console.log('), i(1, ''), t(')'), i(0) }),
  s('jst', { t('JSON.stringify('), i(1, ''), t(', null, 2)'), i(0) }),
}
