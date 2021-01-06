within Buildings.Fluid.SolarCollectors.Data.Tubular;
record T_JiaxingDiyiC0130 =
    SolarCollectors.Data.GenericSolarCollector (
    final ATyp=Types.Area.Gross,
    final A=4.650,
    final mDry=95,
    final V=1.7/1000,
    final dp_nominal=100,
    final mperA_flow_nominal=0.0142,
    final B0=1.4564,
    final B1=-0.9136,
    final y_intercept=0.388,
    final slope=-1.453,
    final IAMDiff=0,
    final C1=0,
    final C2=0,
    final G_nominal=1000,
    final dT_nominal=10) "T - Jiaxing Diyi New Energy Co., Ltd., DIYI-C01-30"
    annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datSolCol",
Documentation(info = "<html>
    <h4>References</h4>
      <p>
        Ratings data taken from the <a href=\"http://www.solar-rating.org\">
        Solar Rating and Certification Corporation website</a>.
        SRCC# = 2012036A.
      </p>
      <p>
        The ratings provided for <code>dp_nominal</code> were suspicious
        so 100 Pa is used instead.<br/>
      </p>
    </html>"));
