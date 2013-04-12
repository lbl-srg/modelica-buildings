within Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate;
record SRCC2007064A =
    SolarCollectors.Data.GlazedFlatPlate.Generic (
    ATyp=Types.Area.Gross,
    Fluid=Types.DesignFluid.Air,
    A=34.495,
    mDry=471.7,
    V=34.495*0.04,
    dp_nominal=0,
    VperA_flow_nominal=5062.2/(10^6),
    B0=-0.10,
    B1=0.0,
    y_intercept=0.515,
    slope=-6.36,
    IAMDiff=0,
    C1=0,
    C2=0) "Air-Based, EchoFirst Inc.: Cleanline-Thermal CL-T-30"
    annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2007064A.<br>
    </p>
    </html>"));
