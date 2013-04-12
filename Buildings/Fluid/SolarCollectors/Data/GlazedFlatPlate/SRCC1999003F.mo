within Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate;
record SRCC1999003F =
    SolarCollectors.Data.GlazedFlatPlate.Generic (
    ATyp=Types.Area.Gross,
    Fluid=Types.DesignFluid.Water,
    A=2.918,
    mDry=69,
    V=8.8/1000,
    dp_nominal=552*1000,
    VperA_flow_nominal=18.4/(10^6),
    B0=-0.1089,
    B1=-0.0002,
    y_intercept=0.708,
    slope=-6.110,
    IAMDiff=0,
    C1=0,
    C2=0) "R&R Solar Supply, Copper Star 32, EPI-308CU(4'x8')"
    annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 1999003F.<br>
    </p>
    </html>"));
