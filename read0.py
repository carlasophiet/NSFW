from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium import webdriver
import re
import csv
from bs4 import BeautifulSoup as soup
import os
import time
from time import sleep

url = '' ##aca habia una pagina porno de xvideos, might not work anymore, cambiaron bocha el html mientras lo hice capaz

print('Hola! Voy a abrir una página solo, like a big boy.')
sleep(1)
print('TRIGGER WARNING, medio jevi.')
sleep(1)
print('Voy a buscar un botón llamado ‘Comments’, lo voy a clickear y esperar. ')
sleep(1)
print('Después voy a buscar un botón llamado ‘Load all comments’ y clickear.')
sleep(1)
print('Si esperé lo suficiente, todo va a estar bien (: sino, un error aparece.')
sleep(1)
print('Después, te mostraré los comentarios, si?')

##luagr donde estar el geckdriver hardcodeado, esto no es una buena practiiica jiji 
driver= webdriver.Firefox(executable_path='/home/miau/geckodriver')
driver.get(url)

titulo= driver.find_element_by_class_name('page-title')
print(titulo.text)

boton = driver.find_element_by_id('tabComments_btn')
boton.click()

wait = WebDriverWait(driver, 700) ## don't sweat it

##element = driver.find_element_by_xpath("//a[.='Load all comments']")
element = driver.find_element_by_class_name('thread-node-children-load-all-btn')
sleep(5)
element.click()

sleep(5)

#wait.until(EC.presence_of_element_located((By.CLASS_NAME, 'thread-node-message')))
c = 0
for elm in driver.find_elements_by_css_selector(".thread-node-message"):
    if c < 100:
        print(elm.text)
        c = c + 1
        sleep(3)
    else:
        driver.quit()

driver.quit()
