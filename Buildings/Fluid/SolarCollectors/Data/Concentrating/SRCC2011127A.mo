within Buildings.Fluid.SolarCollectors.Data.Concentrating;
record SRCC2011127A =
  SolarCollectors.Data.Concentrating.Generic (
    ATyp=Types.Area.Aperture,
    Fluid=Types.DesignFluid.Water,
    A=3.364,
    dp_nominal=1069*1000,
    V=4.4/1000,
    VperA_flow_nominal=24.1/(10^6),
    y_intercept=0.720,
    IAMDiff=0.133,
    C1=2.8312,
    C2=0.00119,
    B0=0,
    B1=0,
    mDry=484,
    slope=0) "Cogenra Solar, SunDeck"
    annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2011127A.<br>
    </p>
    </html>"));
