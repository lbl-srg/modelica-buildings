within Buildings.Fluid.SolarCollectors.Data.Tubular;
record SRCC2012019C =
    SolarCollectors.Data.Tubular.Generic (
    ATyp=Types.Area.Gross,
    Fluid=Types.DesignFluid.Water,
    A=2.345,
    mDry=46,
    V=0.9/1000,
    dp_nominal=900*1000,
    VperA_flow_nominal=19.9/(10^6),
    B0=0.8413,
    B1=-0.5805,
    y_intercept=0.446,
    slope=-1.635,
    IAMDiff=0,
    C1=0,
    C2=0) "Zhejiang Gaodele New Energy Co, Gaodele, GDL-SP58-1800-15"
    annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2012019C.<br>
    </p>
    </html>"));
