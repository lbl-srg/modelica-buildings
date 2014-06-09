within Buildings.Electrical.Types;
type LoadConnection = enumeration(
    wye_to_wyeg "Wye to wye grounded",
    wye_to_delta "Wye to delta")
  "Enumeration that defines the type of connection can be used for three phases unbalanced systems";
