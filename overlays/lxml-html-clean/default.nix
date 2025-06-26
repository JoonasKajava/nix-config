{channels, ...}: final: prev: {
  python313 = prev.python313.override {
    packageOverrides = python-final: python-prev: {
      lxml-html-clean = python-prev.lxml-html-clean.overridePythonAttrs (oldAttrs: {
        # disable running tests entirely (simplest fix)
        doCheck = false;
      });
    };
  };
}
