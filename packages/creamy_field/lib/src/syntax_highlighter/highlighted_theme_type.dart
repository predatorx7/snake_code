import 'package:flutter/widgets.dart' show TextStyle;
import 'package:flutter_highlight/theme_map.dart';

enum HighlightedThemeType {
  a11yDarkTheme,
  a11yLightTheme,
  agateTheme,
  anOldHopeTheme,
  androidstudioTheme,
  arduinoLightTheme,
  artaTheme,
  asceticTheme,
  atelierCaveDarkTheme,
  atelierCaveLightTheme,
  atelierDuneDarkTheme,
  atelierDuneLightTheme,
  atelierEstuaryDarkTheme,
  atelierEstuaryLightTheme,
  atelierForestDarkTheme,
  atelierForestLightTheme,
  atelierHeathDarkTheme,
  atelierHeathLightTheme,
  atelierLakesideDarkTheme,
  atelierLakesideLightTheme,
  atelierPlateauDarkTheme,
  atelierPlateauLightTheme,
  atelierSavannaDarkTheme,
  atelierSavannaLightTheme,
  atelierSeasideDarkTheme,
  atelierSeasideLightTheme,
  atelierSulphurpoolDarkTheme,
  atelierSulphurpoolLightTheme,
  atomOneDarkReasonableTheme,
  atomOneDarkTheme,
  atomOneLightTheme,
  brownPaperTheme,
  codepenEmbedTheme,
  colorBrewerTheme,
  darculaTheme,
  darkTheme,
  defaultTheme,
  doccoTheme,
  draculaTheme,
  farTheme,
  foundationTheme,
  githubGistTheme,
  githubTheme,
  gmlTheme,
  googlecodeTheme,
  gradientDarkTheme,
  grayscaleTheme,
  gruvboxDarkTheme,
  gruvboxLightTheme,
  hopscotchTheme,
  hybridTheme,
  ideaTheme,
  irBlackTheme,
  isblEditorDarkTheme,
  isblEditorLightTheme,
  kimbieDarkTheme,
  kimbieLightTheme,
  lightfairTheme,
  magulaTheme,
  monoBlueTheme,
  monokaiSublimeTheme,
  monokaiTheme,
  nightOwlTheme,
  nordTheme,
  obsidianTheme,
  oceanTheme,
  paraisoDarkTheme,
  paraisoLightTheme,
  pojoaqueTheme,
  purebasicTheme,
  qtcreatorDarkTheme,
  qtcreatorLightTheme,
  railscastsTheme,
  rainbowTheme,
  routerosTheme,
  schoolBookTheme,
  shadesOfPurpleTheme,
  solarizedDarkTheme,
  solarizedLightTheme,
  sunburstTheme,
  tomorrowNightBlueTheme,
  tomorrowNightBrightTheme,
  tomorrowNightEightiesTheme,
  tomorrowNightTheme,
  tomorrowTheme,
  vsTheme,
  vs2015Theme,
  xcodeTheme,
  xt256Theme,
  zenburnTheme,
}

Map<String, TextStyle> getHighlightedThemeStyle(
    HighlightedThemeType highlighterThemeType) {
  switch (highlighterThemeType) {
    case HighlightedThemeType.a11yDarkTheme:
      return themeMap['a11y-dark'];
    case HighlightedThemeType.a11yLightTheme:
      return themeMap['a11y-light'];
    case HighlightedThemeType.agateTheme:
      return themeMap['agate'];
    case HighlightedThemeType.anOldHopeTheme:
      return themeMap['an-old-hope'];
    case HighlightedThemeType.androidstudioTheme:
      return themeMap['androidstudio'];
    case HighlightedThemeType.arduinoLightTheme:
      return themeMap['arduino-light'];
    case HighlightedThemeType.artaTheme:
      return themeMap['arta'];
    case HighlightedThemeType.asceticTheme:
      return themeMap['ascetic'];
    case HighlightedThemeType.atelierCaveDarkTheme:
      return themeMap['atelier-cave-dark'];
    case HighlightedThemeType.atelierCaveLightTheme:
      return themeMap['atelier-cave-light'];
    case HighlightedThemeType.atelierDuneDarkTheme:
      return themeMap['atelier-dune-dark'];
    case HighlightedThemeType.atelierDuneLightTheme:
      return themeMap['atelier-dune-light'];
    case HighlightedThemeType.atelierEstuaryDarkTheme:
      return themeMap['atelier-estuary-dark'];
    case HighlightedThemeType.atelierEstuaryLightTheme:
      return themeMap['atelier-estuary-light'];
    case HighlightedThemeType.atelierForestDarkTheme:
      return themeMap['atelier-forest-dark'];
    case HighlightedThemeType.atelierForestLightTheme:
      return themeMap['atelier-forest-light'];
    case HighlightedThemeType.atelierHeathDarkTheme:
      return themeMap['atelier-heath-dark'];
    case HighlightedThemeType.atelierHeathLightTheme:
      return themeMap['atelier-heath-light'];
    case HighlightedThemeType.atelierLakesideDarkTheme:
      return themeMap['atelier-lakeside-dark'];
    case HighlightedThemeType.atelierLakesideLightTheme:
      return themeMap['atelier-lakeside-light'];
    case HighlightedThemeType.atelierPlateauDarkTheme:
      return themeMap['atelier-plateau-dark'];
    case HighlightedThemeType.atelierPlateauLightTheme:
      return themeMap['atelier-plateau-light'];
    case HighlightedThemeType.atelierSavannaDarkTheme:
      return themeMap['atelier-savanna-dark'];
    case HighlightedThemeType.atelierSavannaLightTheme:
      return themeMap['atelier-savanna-light'];
    case HighlightedThemeType.atelierSeasideDarkTheme:
      return themeMap['atelier-seaside-dark'];
    case HighlightedThemeType.atelierSeasideLightTheme:
      return themeMap['atelier-seaside-light'];
    case HighlightedThemeType.atelierSulphurpoolDarkTheme:
      return themeMap['atelier-sulphurpool-dark'];
    case HighlightedThemeType.atelierSulphurpoolLightTheme:
      return themeMap['atelier-sulphurpool-light'];
    case HighlightedThemeType.atomOneDarkReasonableTheme:
      return themeMap['atom-one-dark-reasonable'];
    case HighlightedThemeType.atomOneDarkTheme:
      return themeMap['atom-one-dark'];
    case HighlightedThemeType.atomOneLightTheme:
      return themeMap['atom-one-light'];
    case HighlightedThemeType.brownPaperTheme:
      return themeMap['brown-paper'];
    case HighlightedThemeType.codepenEmbedTheme:
      return themeMap['codepen-embed'];
    case HighlightedThemeType.colorBrewerTheme:
      return themeMap['color-brewer'];
    case HighlightedThemeType.darculaTheme:
      return themeMap['darcula'];
    case HighlightedThemeType.darkTheme:
      return themeMap['dark'];
    case HighlightedThemeType.doccoTheme:
      return themeMap['docco'];
    case HighlightedThemeType.draculaTheme:
      return themeMap['dracula'];
    case HighlightedThemeType.farTheme:
      return themeMap['far'];
    case HighlightedThemeType.foundationTheme:
      return themeMap['foundation'];
    case HighlightedThemeType.githubGistTheme:
      return themeMap['github-gist'];
    case HighlightedThemeType.githubTheme:
      return themeMap['github'];
    case HighlightedThemeType.gmlTheme:
      return themeMap['gml'];
    case HighlightedThemeType.googlecodeTheme:
      return themeMap['googlecode'];
    case HighlightedThemeType.gradientDarkTheme:
      return themeMap['gradient-dark'];
    case HighlightedThemeType.grayscaleTheme:
      return themeMap['grayscale'];
    case HighlightedThemeType.gruvboxDarkTheme:
      return themeMap['gruvbox-dark'];
    case HighlightedThemeType.gruvboxLightTheme:
      return themeMap['gruvbox-light'];
    case HighlightedThemeType.hopscotchTheme:
      return themeMap['hopscotch'];
    case HighlightedThemeType.hybridTheme:
      return themeMap['hybrid'];
    case HighlightedThemeType.ideaTheme:
      return themeMap['idea'];
    case HighlightedThemeType.irBlackTheme:
      return themeMap['ir-black'];
    case HighlightedThemeType.isblEditorDarkTheme:
      return themeMap['isbl-editor-dark'];
    case HighlightedThemeType.isblEditorLightTheme:
      return themeMap['isbl-editor-light'];
    case HighlightedThemeType.kimbieDarkTheme:
      return themeMap['kimbie.dark'];
    case HighlightedThemeType.kimbieLightTheme:
      return themeMap['kimbie.light'];
    case HighlightedThemeType.lightfairTheme:
      return themeMap['lightfair'];
    case HighlightedThemeType.magulaTheme:
      return themeMap['magula'];
    case HighlightedThemeType.monoBlueTheme:
      return themeMap['mono-blue'];
    case HighlightedThemeType.monokaiSublimeTheme:
      return themeMap['monokai-sublime'];
    case HighlightedThemeType.monokaiTheme:
      return themeMap['monokai'];
    case HighlightedThemeType.nightOwlTheme:
      return themeMap['night-owl'];
    case HighlightedThemeType.nordTheme:
      return themeMap['nord'];
    case HighlightedThemeType.obsidianTheme:
      return themeMap['obsidian'];
    case HighlightedThemeType.oceanTheme:
      return themeMap['ocean'];
    case HighlightedThemeType.paraisoDarkTheme:
      return themeMap['paraiso-dark'];
    case HighlightedThemeType.paraisoLightTheme:
      return themeMap['paraiso-light'];
    case HighlightedThemeType.pojoaqueTheme:
      return themeMap['pojoaque'];
    case HighlightedThemeType.purebasicTheme:
      return themeMap['purebasic'];
    case HighlightedThemeType.qtcreatorDarkTheme:
      return themeMap['qtcreator_dark'];
    case HighlightedThemeType.qtcreatorLightTheme:
      return themeMap['qtcreator_light'];
    case HighlightedThemeType.railscastsTheme:
      return themeMap['railscasts'];
    case HighlightedThemeType.rainbowTheme:
      return themeMap['rainbow'];
    case HighlightedThemeType.routerosTheme:
      return themeMap['routeros'];
    case HighlightedThemeType.schoolBookTheme:
      return themeMap['school-book'];
    case HighlightedThemeType.shadesOfPurpleTheme:
      return themeMap['shades-of-purple'];
    case HighlightedThemeType.solarizedDarkTheme:
      return themeMap['solarized-dark'];
    case HighlightedThemeType.solarizedLightTheme:
      return themeMap['solarized-light'];
    case HighlightedThemeType.sunburstTheme:
      return themeMap['sunburst'];
    case HighlightedThemeType.tomorrowNightBlueTheme:
      return themeMap['tomorrow-night-blue'];
    case HighlightedThemeType.tomorrowNightBrightTheme:
      return themeMap['tomorrow-night-bright'];
    case HighlightedThemeType.tomorrowNightEightiesTheme:
      return themeMap['tomorrow-night-eighties'];
    case HighlightedThemeType.tomorrowNightTheme:
      return themeMap['tomorrow-night'];
    case HighlightedThemeType.tomorrowTheme:
      return themeMap['tomorrow'];
    case HighlightedThemeType.vsTheme:
      return themeMap['vs'];
    case HighlightedThemeType.vs2015Theme:
      return themeMap['vs2015'];
    case HighlightedThemeType.xcodeTheme:
      return themeMap['xcode'];
    case HighlightedThemeType.xt256Theme:
      return themeMap['xt256'];
    case HighlightedThemeType.zenburnTheme:
      return themeMap['zenburn'];
    case HighlightedThemeType.defaultTheme:
    default:
      return themeMap['default'];
  }
}
