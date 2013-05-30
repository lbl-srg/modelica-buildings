within Buildings.Fluid.SolarCollectors.Data.Tubular;
record JiaxingDiyiC0130 =
    SolarCollectors.Data.GenericSolarCollector (
    ATyp=Types.Area.Gross,
    A=4.650,
    mDry=95,
    V=1.7/1000,
    dp_nominal=0.91,
    mperA_flow_nominal=0.0142,
    B0=1.4564,
    B1=-0.9136,
    y_intercept=0.388,
    slope=-1.453,
    IAMDiff=0,
    C1=0,
    C2=0,
    G_nominal=1000,
    dT_nominal=10) "Jiaxing Diyi New Energy Co., Ltd., DIYI-C01-30"
    annotation(Documentation(info = "<html>
    <h4>References</h4>
    <p>
    Ratings data taken from the <a href=\"http://www.solar-rating.org\">Solar Rating Certification Corporation website</a>.
    SRCC# = 2012036A.<br>
    </p>
    </html>"));
