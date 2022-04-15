extends Node2D

var numberEquation = 1
var currentLevel = 0
var correctAnswers = 0
var numbersFromTo = []

var isGamerOver = false

var currentOperation = 0
var currentResult = 0

signal continueTime

func _ready():
	randomize()
	
	updateOperation()
	
	$Timer.wait_time += 1
	$Timer.start()
	$NumberEquation.text = "Equation " + str(numberEquation)
	
	numbersFromTo = getNumberRange(currentLevel)

func _process(delta):
	
	$TimerLabel.text = str( int( $Timer.time_left) )
	
	if Input.is_action_just_pressed("ui_accept") and not $AnswerStatus.visible:
		
		var strAnswer = $Answer.text
		var newString = ""
		
		for c in strAnswer:
			if c != '\n' or c != ' ':
				newString += c
				
		$Answer.text = newString
		
		if len(newString) != 0:
			_on_Check_pressed()

func _on_Check_pressed():
	$Answer.readonly = true
	numberEquation += 1
		
	currentResult = stepify(currentResult, 0.01)
	
	# Check answer
	var correctAnswerToType = float(str(currentResult))
	if correctAnswerToType == float($Answer.text):
		correctAnswers +=1
		$CorrectAnswers.text = "Corrects: " + str(correctAnswers)
		showStatusAnswer(true, correctAnswerToType)
		
		if correctAnswers % 8 == 0:
			currentLevel += 1
			
			numbersFromTo = getNumberRange(currentLevel)
		
		if correctAnswers > Globals.bestMark:
			Globals.bestMark = correctAnswers
			$BestMark.text = "Best Mark: " + str(Globals.bestMark)
		
	else:
		showStatusAnswer(false, correctAnswerToType)
	
func updateOperation():
	var to = 4
	
	if currentLevel == 1:
		to = 6
	elif currentLevel == 3:
		to = 8
	elif currentLevel == 4:
		to = 12

	numbersFromTo = getNumberRange(currentLevel)
	currentOperation = getRandomOperation(numbersFromTo[0],numbersFromTo[1])
	$Equation.text = currentOperation[0]
	currentResult = currentOperation[1]
	
	$Answer.grab_focus()

func getRandomOperation(from, to):
	var num1 = int(randi() % to + from)
	var num2 = int(randi() % to + from)
	
	var operator = int(randi() % 4 + 1) # 1: "+", 2: "-", 3: "*", 4: "/"
	
	var result = 0
	var operatorSymbol = ""
	
	if operator == 1:
		result = num1 + num2
		operatorSymbol = "+"
	elif operator == 2:
		result = num1 - num2
		operatorSymbol = "-"
	elif operator == 3:
		result = num1 * num2
		operatorSymbol = "*"
	elif operator == 4:
		while num2 == 0:
			num2 = int(randi() % to + from)
		
		result = num1 / float(num2)
		operatorSymbol = "/"
		
	print(operatorSymbol)
	print(result)
	
	return [ str(num1) + " "+ operatorSymbol + " " + str(num2), result]
	


func _on_Timer_timeout():
	print("Time Over")
		
	$TimerOver.visible = true
	$Timer.stop()
	
	$TimerOver/LabelYourMark.text = "Your mark: " + str(correctAnswers)
	$TimerOver/LabelBestMark.text = "Best mark: " + str(Globals.bestMark)
	
	get_tree().paused = true

func showStatusAnswer(isCorrect, correctAnswer):
	$AnswerStatus.startTimer()
	
	if isCorrect:
		$AnswerStatus/LabelCorrectAnswer.visible = false
		$AnswerStatus/Label.text = "Excellent!"
		$AnswerStatus.visible = true
		$Timer.paused = true
		$AnswerStatus/Timer.start();
		$AnswerStatus/CorrectSound.play()
		print("ejecutado")
	else:
		$AnswerStatus/LabelCorrectAnswer.visible = true
		$AnswerStatus/LabelCorrectAnswer.text = "Answer:\n" + str(correctAnswer)
		$AnswerStatus/Label.text = "Incorrect!"
		$AnswerStatus.visible = true
		$Timer.paused = true
		$AnswerStatus/Timer.start();


func _on_Game_continueTime():
	$Timer.paused = false
	updateOperation()
	$Answer.text = ""
	
	$Answer.readonly = false
	$NumberEquation.text = "Equation " + str(numberEquation)


func _on_ButtonGoToMenu_pressed():
	get_tree().change_scene("res://Menu/Menu.tscn")


func _on_ButtonTryAgain_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Game/Game.tscn")

func getNumberRange(level):
	var r = [0, 4]
	
	if level == 2:
		r = [2, 6]
	elif level == 3:
		r = [2, 8]
	elif level == 4:
		r = [3, 10]
	elif level == 5:
		r = [3, 12]
	elif level == 6:
		r = [4, 14]
	elif level == 7:
		r = [4, 16]
	elif level == 8:
		r = [5, 18]
	elif level == 9:
		r = [5, 20]
	elif level == 10:
		r = [6, 25]
	elif level > 10:
		r = [randi() % 5 + 1, level * 2 + 5]
	
	return r



func _on_Answer_text_changed():
	var newStr = ""
	for c in $Answer.text:
		if c == '1':
			newStr += c
		if c == '2':
			newStr += c
		if c == '3':
			newStr += c
		if c == '4':
			newStr += c
		if c == '5':
			newStr += c
		if c == '6':
			newStr += c
		if c == '7':
			newStr += c
		if c == '8':
			newStr += c
		if c == '9':
			newStr += c
		if c == '0':
			newStr += c
		if c == '-':
			newStr += c
		if c == '.':
			newStr += c
			
	$Answer.text = newStr
	$Answer.cursor_set_column(len($Answer.text))
