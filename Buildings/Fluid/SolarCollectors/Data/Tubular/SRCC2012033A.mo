within Buildings.Fluid.SolarCollectors.Data.Tubular;
record SRCC2012033A =
    SolarCollectors.Data.Tubular.Generic (
    ATyp=Types.Area.Gross,
    Fluid=Types.DesignFluid.Water,
    A=4.673,
    mDry=111,
    V=2.3/1000,
    dp_nominal=1*1000,
    VperA_flow_nominal=20.1/(10^6),
    B0=1.3766,
    B1=-0.9294,
    y_intercept=0.422,
    slope=-1.864,
    IAMDiff=0,
    C1=0,
    C2=0) "G.S. Inc., Suntask, SR30"
    annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2012033A.<br>
    </p>
    </html>"));
