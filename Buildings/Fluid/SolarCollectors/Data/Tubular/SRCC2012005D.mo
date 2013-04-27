within Buildings.Fluid.SolarCollectors.Data.Tubular;
record SRCC2012005D =
    SolarCollectors.Data.GenericSolarCollector (
    ATyp=Types.Area.Gross,
    A=3.431,
    mDry=73,
    V=2/1000,
    dp_nominal=900*1000,
    mperA_flow_nominal=0.0111,
    B0=1.1803,
    B1=-0.762,
    y_intercept=0.371,
    slope=-1.225,
    IAMDiff=0,
    C1=0,
    C2=0) "Westech Solar Technology Wuxi Co, Westech, WT-B58-20"
    annotation(Documentation(info = "<html>
    <h4>References</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2012005D.<br>
    </p>
    </html>"));
