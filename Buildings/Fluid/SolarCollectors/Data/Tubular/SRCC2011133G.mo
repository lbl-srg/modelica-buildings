within Buildings.Fluid.SolarCollectors.Data.Tubular;
record SRCC2011133G =
    SolarCollectors.Data.Tubular.Generic (
    ATyp=Types.Area.Gross,
    Fluid=Types.DesignFluid.Water,
    A=3.624,
    mDry=68,
    V=2.6/1000,
    dp_nominal=900*1000,
    VperA_flow_nominal=17.9/(10^6),
    B0=0.125,
    B1=-0.0163,
    y_intercept=0.609,
    slope=-1.051,
    IAMDiff=0,
    C1=0,
    C2=0) "Evosolar, EVOT-21"
    annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2011133G.<br>
    </p>
    </html>"));
