within Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate;
record FP_SolahartKf =
    Buildings.Fluid.SolarCollectors.Data.GenericASHRAE93 (
    final ATyp=Types.Area.Gross,
    final A=2.003,
    final mDry=42,
    final V=3.8/1000,
    final dp_nominal=93.89,
    final mperA_flow_nominal=0.0194,
    final B0=-0.137,
    final B1=0.0166,
    final y_intercept=0.775,
    final slope=-5.103,
    final G_nominal=1000,
    final dT_nominal=10) "FP - Solahart Kf"
    annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datSolCol",
Documentation(info = "<html>
    <h4>References</h4>
      <p>
        Ratings data taken from the <a href=\"http://www.solar-rating.org\">
        Solar Rating and Certification Corporation website</a>. SRCC# = 2012021A.<br/>
      </p>
    </html>"));
