within Buildings.Fluid.SolarCollectors.Data.Concentrating;
record C_VerificationModel =
  Buildings.Fluid.SolarCollectors.Data.GenericEN12975 (
    final ATyp=Types.Area.Aperture,
    final A=4.302,
    final V=4.4/1000,
    final dp_nominal = 100,
    final mperA_flow_nominal=0.0241,
    final y_intercept=0.720,
    final IAMDiff=0.133,
    final C1=2.8312,
    final C2=0.00119,
    final B0=0,
    final B1=0,
    final mDry=484,
    final slope=0,
    final G_nominal = 1000,
    final dT_nominal = 20)
  "C - All inputs necessary for verification of EN12975 models"
    annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datSolCol",
Documentation(info = "<html>
      <p>
        No model on the <a href=\"http://www.solar-rating.org\"> Solar Rating and
        Certification Corporation </a> website tested to EN12975 standards provides all
        of the necessary information for modeling. Specific limitations are
        <code>dp_nominal</code>, <code>G_nominal</code> and <code>dT_nominal</code>.
        This data record was created to allow verification of EN12975 base classes
        despite the limitations in available data.
      </p>
    </html>"));
