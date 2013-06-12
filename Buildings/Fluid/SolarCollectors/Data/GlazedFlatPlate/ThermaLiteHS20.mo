within Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate;
record ThermaLiteHS20 =
    SolarCollectors.Data.GenericSolarCollector (
    ATyp=Types.Area.Gross,
    A=1.97,
    mDry=26,
    V=2.8/1000,
    dp_nominal=19848,
    mperA_flow_nominal=0.1777,
    B0=-0.0693,
    B1=-0.2372,
    y_intercept=0.762,
    slope=-3.710,
    IAMDiff=0,
    C1=0,
    C2=0,
    G_nominal = 1000,
    dT_nominal = 10) "Therma-Lite, HS-20"
    annotation(Documentation(info = "<html>  
    <h4>References</h4>
    <p>
    Ratings data taken from the <a href=\"http://www.solar-rating.org\">
    Solar Rating Certification Corporation website</a>. SRCC# = 2012047A.<br/>
    </p>
    </html>"));
