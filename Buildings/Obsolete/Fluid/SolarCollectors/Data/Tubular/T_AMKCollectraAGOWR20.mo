within Buildings.Obsolete.Fluid.SolarCollectors.Data.Tubular;
record T_AMKCollectraAGOWR20 =
    SolarCollectors.Data.GenericSolarCollector (
    final ATyp=Types.Area.Gross,
    final A=3.457,
    final mDry=73,
    final V=3.5/1000,
    final dp_nominal=100,
    final mperA_flow_nominal=0.0201,
    final B0=0.5722,
    final B1=-0.0052,
    final y_intercept=0.446,
    final slope=-1.432,
    final IAMDiff=0,
    final C1=0,
    final C2=0,
    final G_nominal = 1000,
    final dT_nominal = 10) "T - AMG Collectra AG, OWR 20"
    annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datSolCol",
Documentation(info = "<html>
    <h4>References</h4>
      <p>
        Ratings data taken from the <a href=\"http://www.solar-rating.org\">
        Solar Rating and Certification Corporation website</a>.
        SRCC# = 2012018A.
      </p>
      <p>
        The ratings provided for <code>dp_nominal</code> were suspicious
        so 100 Pa is used instead.<br/>
      </p>
    </html>"));
