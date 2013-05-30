within Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate;
record SolahartKf =
    SolarCollectors.Data.GenericSolarCollector (
    ATyp=Types.Area.Gross,
    A=2.003,
    mDry=42,
    V=3.8/1000,
    dp_nominal=100,
    mperA_flow_nominal=0.0194,
    B0=-0.137,
    B1=0.0166,
    y_intercept=0.775,
    slope=-5.103,
    IAMDiff=0,
    C1=0,
    C2=0,
    G_nominal=1000,
    dT_nominal=10) "Solahart Kf"
    annotation(Documentation(info = "<html>
    <h4>References</h4>
    <p>
    Ratings data taken from the <a href=\"http://www.solar-rating.org\">Solar Rating Certification Corporation website</a>. SRCC# = 2012021A.
    </p>
    </html>"));
