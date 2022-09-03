describe('example counter app', () => {
  beforeEach(() => {
    cy.visit('http://127.0.0.1:5500/index.html')
  })

  it('최초 카운터 값을 0으로 보여준다', () => {
    cy.get('#value')
      .invoke('text')
      .should('eq', '0')
  })

  it('+ 버튼을 클릭 시 count가 1 증가한다.', () => {
    cy.get('#value')
      .invoke('text')
      .then((value) =>{
        const preValue = Number(value)
        cy.get('.buttons__plus').click()
        cy.get('#value')
          .invoke('text')
          .should('eq', String(preValue + 1))
    })
  })
})