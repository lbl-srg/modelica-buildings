within Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate;
record SRCC2012025I =
    SolarCollectors.Data.GlazedFlatPlate.Generic (
    ATyp=Types.Area.Gross,
    Fluid=Types.DesignFluid.Water,
    A=0.8,
    mDry=15,
    V=1.1/1000,
    dp_nominal=900*1000,
    VperA_flow_nominal=19.7/(10^6),
    B0=-0.4677,
    B1=-0.0002,
    y_intercept=0.582,
    slope=-3.822,
    IAMDiff=0,
    C1=0,
    C2=0) "Boen Solar Technology Co, KLB-1008-E"
    annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2012025I.<br>
    </p>
    </html>"));
