within Buildings.Electrical.Interfaces;
partial model PartialRenewableAcDc
  "Partial model that contains basic parameters for a DC/AC conversion system"
  parameter Real pf(min=0, max=1) = 0.9 "Power factor"
    annotation (Dialog(group="AC-Conversion"));
  parameter Real eta_DCAC(min=0, max=1) = 0.9 "Efficiency of DC/AC conversion"
    annotation (Dialog(group="AC-Conversion"));
end PartialRenewableAcDc;
