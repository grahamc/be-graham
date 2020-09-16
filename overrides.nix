self: super: {
  grahamc = super.grahamc.extend (gcself: gcsuper: {
    about = gcsuper.about.extend (_: _: self.grahamc.lib.loadJsonOr ./about.json { });
  });
}
