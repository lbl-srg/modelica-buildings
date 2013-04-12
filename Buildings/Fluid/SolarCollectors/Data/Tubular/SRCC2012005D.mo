within Buildings.Fluid.SolarCollectors.Data.Tubular;
record SRCC2012005D =
    SolarCollectors.Data.Tubular.Generic (
    ATyp=Types.Area.Gross,
    Fluid=Types.DesignFluid.Water,
    A=3.431,
    mDry=73,
    V=2/1000,
    dp_nominal=900*1000,
    VperA_flow_nominal=11.1/(10^6),
    B0=1.1803,
    B1=-0.762,
    y_intercept=0.371,
    slope=-1.225,
    IAMDiff=0,
    C1=0,
    C2=0) "Westech Solar Technology Wuxi Co, Westech, WT-B58-20"
    annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2012005D.<br>
    </p>
    </html>"));
