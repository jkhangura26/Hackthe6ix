function getRadioValue(name) {
    const radios = document.getElementsByName(name);
    for (const radio of radios) {
      if (radio.checked) {
        return parseInt(radio.value);
      }
    }
    return 0;
  }
  function getScore() {
    const carCommuting = getRadioValue('car-commuting');
    const carType = getRadioValue('car-type');
    const carMiles = getRadioValue('miles');
    const transportationScore = (carCommuting + carType + carMiles) / 3;
    const houseScore = getRadioValue('house-type');
    const dietScore = getRadioValue('food');
    const wasteConsumptionScore = getRadioValue('garbage');
    const travelScore = getRadioValue('airplane');
    const finalScore = 0.3 * transportationScore + 0.3 * houseScore + 0.2 * dietScore + 0.1 * wasteConsumptionScore + 0.1 * travelScore;
    document.getElementById('score').innerText = finalScore.toFixed(2);
  }
  