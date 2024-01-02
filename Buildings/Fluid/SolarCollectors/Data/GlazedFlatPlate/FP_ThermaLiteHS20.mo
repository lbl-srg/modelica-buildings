within Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate;
record FP_ThermaLiteHS20 =
    Buildings.Fluid.SolarCollectors.Data.GenericASHRAE93 (
    final ATyp=Types.Area.Gross,
    final A=1.97,
    final mDry=26,
    final V=2.8/1000,
    final dp_nominal=242.65,
    final mperA_flow_nominal=0.1777,
    final B0=-0.0693,
    final B1=-0.2372,
    final y_intercept=0.762,
    final slope=-3.710,
    final G_nominal = 1000,
    final dT_nominal = 10) "FP - Therma-Lite, HS-20"
    annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datSolCol",
Documentation(info = "<html>
    <h4>References</h4>
      <p>
        Ratings data taken from the <a href=\"http://www.solar-rating.org\">
        Solar Rating and Certification Corporation website</a>. SRCC# = 2012047A.
      </p>
    </html>"));
