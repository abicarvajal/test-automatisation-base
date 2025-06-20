@REQ @abcarvaj
Feature: Manejo de API

  Background:
    Given url "http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api"
    Given path "characters"
    When method Get
    Then status 200
    * def personajeResponse = response[0].id
    * print personajeResponse

  Scenario: Consulta Personajes
    Given path "characters"
    When method Get
    Then status 200
    * print response
    And match response != null

  Scenario Outline: Consulta Personajes por id (exitoso)
    Given path "characters", <idPersonaje>
    When method Get
    Then status 200
    * print response
    And match response != null
    Examples:
      | read("data/data-test.csv") |

  Scenario Outline: Consulta Personajes por id (fallido)
    Given path "characters", <idPersonaje>
    When method Get
    Then status 404
    * print response
    And match response != null
    And match response.error == "Character not found"
    Examples:
      | read("data/data-error.csv") |

  Scenario Outline: Crea Personaje (Caso: exitoso)
    Given path "characters"
    * def randomName = 'Character-' + Math.floor(Math.random() * 10000)
    * print randomName
    * def randomDescription = 'Description-' + Math.floor(Math.random() * 10000)
    * print randomDescription
    * def randomPower = 'Power-' + Math.floor(Math.random() * 10000)
    * print randomPower
    * def randomAlter = 'Alter-' + Math.floor(Math.random() * 10000)
    * print randomAlter
    * def requestBody = {name: '#(randomName)',       description: '#(randomDescription)', powers: ['#(randomPower)'], alterego: '#(randomAlter)'}
    * print requestBody
    And request requestBody
    When method POST
    Then status 201
    * print response
    And match response != null
    And match response.name == randomName
    And match response.description == randomDescription
    Examples:
      | read("data/data-test.csv") |

  Scenario Outline: Crea Personaje (Caso:duplicado)
    Given path "characters"
    And request read("data/request-body.json")
    When method POST
    Then status 400
    * print response
    And match response != null
    And match response.error == "Character name already exists"
    Examples:
      | read("data/data-test.csv") |

  Scenario Outline: Crea Personaje (Caso:faltan campos requeridos)
    Given path "characters"
    And request read("data/incomplete-body.json")
    When method POST
    Then status 400
    * print response
    And match response != null
    And match response == read("data/response-body.json")
    Examples:
      | read("data/data-test.csv") |

  Scenario Outline: Actualiza Personaje por ID (exitoso)
    Given path "characters", <idPersonaje>
    And request read("data/update-body.json")
    When method PUT
    Then status 200
    * print response
    And match response != null
    And match response.id == <idPersonaje>
    And match response.description == "Genius billionaire and philanthropist"
    Examples:
      | read("data/data-test.csv") |

  Scenario Outline: Actualiza Personaje por ID (no existe)
    Given path "characters", <idPersonaje>
    And request read("data/update-body.json")
    When method PUT
    Then status 404
    * print response
    And match response != null
    And match response.error == "Character not found"
    Examples:
      | read("data/data-error.csv") |

  Scenario Outline: Elimina personaje por ID (fallido)
    Given path "characters", <idPersonaje>
    When method Delete
    Then status 404
    * print response
    And match response != null
    And match response.error == "Character not found"
    Examples:
      | read("data/data-error.csv") |

  Scenario: Elimina personaje por ID (exitoso)
    Given path "characters", personajeResponse
    When method Delete
    Then status 204
    * print personajeResponse
    * print response
    And match response != null